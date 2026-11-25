import from "node:process" { default as process }

# Opt-in system-date injection (#1931): open models often do not know today's
# date, which stales their web searches, but a changed prompt defeats provider
# caching and collides with agents that state the date themselves. 'off' (the
# default), 'web_search' (only with a web-search tool or Playground's search
# context) or 'always'. Date only, so a cache holds for the whole UTC day, and
# never where a system or developer message already states it.
type ToolLike = any;

type SystemDateMode = any;

glob SYSTEM_DATE_SETTING: str = "inject_system_date",
     SYSTEM_DATE_MODES: list[str] = ["off", "web_search", "always"];

glob:priv TOOL_NAME: any = rx(
              "^(?:web[_-]?search|search[_-]?web|internet[_-]?search|google[_-]?search|tavily[_-]?search|brave[_-]?search|exa[_-]?search|duckduckgo[_-]?search)(?:_\\d{4}_\\d{2}_\\d{2})?$",
              "i",
          ),
          TOOL_TYPE: any = rx("^web_search(?:_preview)?(?:_\\d{4}_\\d{2}_\\d{2})?$", "i"),
          DATE_MARKER: any = rx(
              "(?:\\bcurrent\\s+(?:date|time)\\s*[:=]|today(?:'s)?\\s+date\\s+is\\b|\\btoday\\s+is\\s+\\d{4}-\\d{2}-\\d{2}\\b)",
              "i",
          ),
          SPELLINGS: dict[str, str] = {
              "off": "off",
              "false": "off",
              "0": "off",
              "web_search": "web_search",
              "web-search": "web_search",
              "search": "web_search",
              "always": "always",
              "on": "always",
              "true": "always",
              "1": "always",
          };

def:priv parseSystemDateMode(raw: any = None) -> any {
    return SPELLINGS.get(raw.strip().lower()) if isinstance(raw, str) else None;
}

# The dashboard setting, then FREELLMAPI_INJECT_SYSTEM_DATE, then 'off'.
def getSystemDateMode -> str {
    try {
        stored = parseSystemDateMode(getSetting(SYSTEM_DATE_SETTING));
    } except Exception {
        stored = None;
    }
    return stored or parseSystemDateMode(process.env.FREELLMAPI_INJECT_SYSTEM_DATE) or "off";
}

def setSystemDateMode(mode: str) -> str {
    setSetting(SYSTEM_DATE_SETTING, mode);
    return mode;
}

def formatSystemDatePrompt(now: any = None) -> str {
    return f"Current date: {(now or new(globalThis.Date)).toISOString()[:10]} (UTC).";
}

def:priv systemTexts(messages: any) -> list[str] {
    return [
        contentToString(m.content)
        for m in messages
        if globalThis.String(m.role) in ["system", "developer"]
    ];
}

def hasWebSearchInRequest(messages: any, tools: any = None) -> bool {
    for tool in tools or [] {
        kind: any = getattr(tool, "type", None) if tool else None;
        fn: any = getattr(tool, "function", None) if tool else None;
        name: any = getattr(fn, "name", None) if fn else None;
        if (isinstance(kind, str) and TOOL_TYPE.test(kind))
            or (isinstance(name, str) and TOOL_NAME.test(name.strip()))
        {
            return True;
        }
    }
    return any('Web search results for "' in text for text in systemTexts(messages));
}

def alreadyHasDateContext(messages: any) -> bool {
    return any(DATE_MARKER.test(text) for text in systemTexts(messages));
}

# Returns the caller's own array when it adds nothing.
def maybeInjectSystemDate(messages: any, opts: any = None) -> any {
    mode = (getattr(opts, "mode", None) if opts else None) or getSystemDateMode();
    tools: any = getattr(opts, "tools", None) if opts else None;
    if mode == "off"
        or (mode == "web_search" and not hasWebSearchInRequest(messages, tools))
        or alreadyHasDateContext(messages)
    {
        return messages;
    }
    now: any = getattr(opts, "now", None) if opts else None;
    return [plain(role="system", content=formatSystemDatePrompt(now)), *messages];
}
