export function getBaseUrl(uiContext?: UIContext): string {
  if (!uiContext) {
    return '';
  }
  const context = uiContext.getHostContext?.();
  if (!context) {
    return '';
  }
  try {
    const name = context.resourceManager.getStringSync($r('app.string.name').id);
    const baseUrl = context.resourceManager.getStringSync($r('app.string.baseurl').id);
    return `https://www.${name}${baseUrl}`;
  } catch (e) {
    return '';
  }
}

export function getApiKey(uiContext?: UIContext): string {
  if (!uiContext) {
    return '';
  }
  const context = uiContext.getHostContext?.();
  if (!context) {
    return '';
  }
  try {
    return context.resourceManager.getStringSync($r('app.string.api_key').id);
  } catch (e) {
    return '';
  }
}

export function getUrl(uiContext?: UIContext): string {
  if (!uiContext) {
    return '';
  }
  const context = uiContext.getHostContext?.();
  if (!context) {
    return '';
  }
  try {
    const name = context.resourceManager.getStringSync($r('app.string.name').id);
    const urlPath = context.resourceManager.getStringSync($r('app.string.url').id);
    return `https://www.${name}${urlPath}&key=${getApiKey(uiContext)}`;
  } catch (e) {
    return '';
  }
}
