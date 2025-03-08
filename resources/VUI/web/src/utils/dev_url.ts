import isDev from "./isDev.ts";

export default function(source: string) {
    // @ts-ignore
    return isDev ? source : `nui://${GetParentResourceName()}/web/dist/${source}`;
}