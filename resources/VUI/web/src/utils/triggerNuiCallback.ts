import isDev from "./isDev.ts";

export default function triggerNuiCallback(action: string, data?: any) {
    if (isDev) return console.log(`[NUI] ${action}`, data);
    // @ts-ignore
    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        body: JSON.stringify(data),
    });
}