export interface DocumentBlockOk {
    ok: true;
    text: string;
}
export interface DocumentBlockRejected {
    ok: false;
    reason: string;
}
export type DocumentBlockResult = DocumentBlockOk | DocumentBlockRejected;
export declare function fenceTag(content: string): string;
export declare function labelTitle(raw: unknown): string;
export declare function convertDocumentBlock(block: unknown): DocumentBlockResult;
export declare function documentRejectionMessage(reasons: string[]): string;
