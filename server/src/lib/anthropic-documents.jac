import from "crypto" { default as crypto }

# Anthropic `document` blocks, on a surface whose providers take only text and
# images. Dropped silently, a client attaching a PDF would get a confident
# answer about a document the model never saw. `text` and `content` sources
# are text already and are passed through; `base64` and `url` need a real
# converter that nothing here has, so they are refused with a message.
# Stringifying the block would put a whole base64 payload in the prompt.
type DocumentBlockOk = any;

type DocumentBlockRejected = any;

type DocumentBlockResult = any;

# C0 controls, DEL and C1, which can carry terminal escapes.
glob:priv CONTROL_CHARS: str = "[\\u0000-\\u001f\\u007f-\\u009f]";

# Derived from the content, not random (a block may carry cache_control, and
# a nonce would bust the provider's cache), nor the client's title (which
# could close the fence early). A tag the content already holds is skipped.
def fenceTag(content: str) -> str {
    digest: str = crypto.createHash("sha256").update(content, "utf8").digest("hex");
    for offset in range(0, len(digest) - 11, 12) {
        candidate = "document-" + digest[offset:offset + 12];
        if candidate not in content {
            return candidate;
        }
    }
    return "document-" + digest[:12];
}

# No controls, no <>" (which break out of the tag), single spaces, at most 120.
def labelTitle(raw: any = None) -> str {
    if not isinstance(raw, str) {
        return "document";
    }
    cleaned = sub(
        sub(sub(raw, CONTROL_CHARS, " ", "g"), "[<>\x22]", "", "g"), "\\s+", " ", "g"
    ).strip()[:120].strip();
    return cleaned or "document";
}

def:priv textFromContentSource(content: any) -> str {
    if isinstance(content, str) {
        return content;
    }
    if not globalThis.Array.isArray(content) {
        return "";
    }
    texts: list[str] = [];
    for b in content {
        t: any = b if isinstance(b, str) else getattr(b, "text", None) if b else None;
        if isinstance(t, str) and t {
            texts.append(t);
        }
    }
    return "\n".join(texts);
}

def:priv field(o: any, name: str) -> str {
    value: any = getattr(o, name, None);
    return value if isinstance(value, str) else "";
}

def convertDocumentBlock(block: any = None) -> any {
    source: any = getattr(block, "source", None) if block else None;
    if not source or globalThis.Object(source) is not source {
        return plain(ok=False, reason="a document block without a `source`");
    }
    kind = field(source, "type");
    if kind == "url" {
        return plain(ok=False, reason="a document block with a `url` source");
    }
    if kind not in ["text", "content"] {
        return plain(
            ok=False,
            reason=f"a document block of type {field(source, 'media_type') or kind or 'unknown'}",
        );
    }
    body = field(source, "data")
        if kind == "text"
        else textFromContentSource(getattr(source, "content", None));
    if not body.strip() {
        return plain(ok=False, reason="a document block whose text source is empty");
    }
    tag = fenceTag(body);
    title = labelTitle(getattr(block, "title", None));
    return plain(ok=True, text=f"<{tag} title=\"{title}\">\n{body}\n</{tag}>");
}

# What was wrong, then what to do instead.
def documentRejectionMessage(reasons: list[str]) -> str {
    unique: list[str] = [];
    for r in reasons {
        if r not in unique {
            unique.append(r);
        }
    }
    extra = f", and {len(unique) - 3} more" if len(unique) > 3 else "";
    return f"This request contains {', '.join(unique[:3])}{extra}. Binary document attachments are not supported: no provider in the pool accepts them, and forwarding the request anyway would silently drop the attachment from the prompt. Send the text instead — either a `text` content block, or a document block with a `text` or `content` source, both of which are passed through.";
}
