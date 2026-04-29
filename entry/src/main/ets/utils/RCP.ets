import { rcp } from '@kit.RemoteCommunicationKit';
import { getBaseUrl } from './Constants';

function sessionConfig(uiContext: UIContext): rcp.SessionConfiguration {
  return {
    baseAddress: getBaseUrl(uiContext)
  };
}

export async function getHttp(uiContext: UIContext, url: string) {
  try {
    const session = rcp.createSession(sessionConfig(uiContext))
    try {
      const res = await session.get(url)
      return res.toJSON()
    } finally {
      session.close()
    }
  } catch (e) {
    console.error('RCP: request failed:', e)
    throw new Error(`RCP request failed: ${JSON.stringify(e)}`)
  }
}
