export default function triggerNuiEvent<T>(action: string, data?: T) {
    // Trigger the message event in the client
    window.dispatchEvent(
        new MessageEvent('message', {
            data: { action, data },
        })
    );
}