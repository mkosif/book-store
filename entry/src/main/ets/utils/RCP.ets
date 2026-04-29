import { rcp } from '@kit.RemoteCommunicationKit';
import { getBaseUrl } from './Constants';

function sessionConfig(uiContext: UIContext): rcp.SessionConfiguration {
  return {
    baseAddress: getBaseUrl(uiContext)
  };
}

function errorText(error: Error): string {
  return error.message || error.name || 'Unknown network error'
}

export async function getHttp(uiContext: UIContext, url: string) {
  try {
    const session = rcp.createSession(sessionConfig(uiContext))
    try {
      const res = await session.get(url)
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw new Error(`HTTP ${res.statusCode}`)
      }
      return res.toJSON()
    } finally {
      session.close()
    }
  } catch (e) {
    const error = e as Error
    console.error('RCP: request failed:', errorText(error))
    throw new Error(errorText(error))
  }
}
