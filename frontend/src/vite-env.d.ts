/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_JANUS_WS_URL: string;
  readonly VITE_TURN_SERVER: string;
  readonly VITE_TURN_USERNAME: string;
  readonly VITE_TURN_CREDENTIAL: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
