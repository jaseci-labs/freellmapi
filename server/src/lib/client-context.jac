import from "async_hooks" { AsyncLocalStorage }
import from "node:process" { default as process }

# The caller's identity for one request, readable below the middleware by
# every path that logs a request.
type ClientContext = any;

glob:priv storage: any = new(AsyncLocalStorage);

def:priv context(ip: any = NULL, userAgent: any = NULL, agent: any = NULL) -> any {
    return plain(ip=ip, userAgent=userAgent, agent=agent);
}

# REQUEST_ANALYTICS_LOG_CLIENT=false stores nulls. It is read per request. With
# `trust proxy` off req.ip is the socket peer, so a spoofed X-Forwarded-For is
# ignored (#1024); an IPv4-mapped IPv6 address is stored as IPv4.
def clientContextMiddleware(req: any, _res: any, next: any) {
    if process.env.REQUEST_ANALYTICS_LOG_CLIENT == "false" {
        storage.run(context(), next);
        return;
    }
    ua: any = req.headers["user-agent"];
    ip: any = getattr(req, "ip", None) ?? getattr(req.socket, "remoteAddress", None);
    storage.run(
        context(
            sub(ip, "^::ffff:", "", "i") if ip else NULL,
            ua.slice(0, 256) if isinstance(ua, str) else NULL,
            classifyClientAgent(req),
        ),
        next,
    );
}

def getClientContext -> any {
    return storage.getStore() ?? context();
}

# The preset a decision model picked for this request (#1354); nothing outside
# a request scope, which then routes as Balanced.
def setRequestRoutingStrategy(strategy: any = None) {
    store: any = storage.getStore();
    if store {
        store.routingStrategy = strategy;
    }
}
