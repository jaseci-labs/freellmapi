type Scheduler = any;

obj NodeScheduler {
    def every(ms: float, fn: any, _opts: any = None) -> any {
        id = globalThis.setInterval(lambda { fn(); }, ms);
        return lambda { globalThis.clearInterval(id); };
    }

    def after(ms: float, fn: any) -> any {
        id = globalThis.setTimeout(lambda { fn(); }, ms);
        return lambda { globalThis.clearTimeout(id); };
    }
}
