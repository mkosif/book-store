import { rcp } from '@kit.RemoteCommunicationKit';
import { getBaseUrl } from './Constants';

function sessionConfig(uiContext: UIContext): rcp.SessionConfiguration {
  return {
    baseAddress: getBaseUrl(uiContext)
  };
}

export async function getHttp(uiContext: UIContext, url: string) {
  const session = rcp.createSession(sessionConfig(uiContext))
  try {
    const res = await session.get(url)
    try {
      return res.toJSON()
    } catch (e) {
      console.error('RCP: failed to serialize response:', e)
      throw new Error(`RCP serialization failed: ${JSON.stringify(e)}`)
    }
  } catch (e) {
    console.error('RCP: request failed:', e)
    throw new Error(`RCP request failed: ${JSON.stringify(e)}`)
  } finally {
    session.close()
  }
}
