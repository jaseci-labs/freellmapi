export declare class OneTimeCode {
    generate(): string;
    get(): string | null;
    clear(): void;
    matches(provided: unknown): boolean;
}
export declare function createOneTimeCode(): OneTimeCode;
