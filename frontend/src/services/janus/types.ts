// Janus message types
export interface JanusMessage {
  janus: string;
  transaction?: string;
  session_id?: number;
  handle_id?: number;
  [key: string]: unknown;
}

export interface JanusTrickleCandidate extends RTCIceCandidateInit {
  completed?: boolean;
}

export interface JanusResponse extends JanusMessage {
  sender?: number;
  reason?: string;
  data?: {
    id?: number;
    [key: string]: unknown;
  };
  plugindata?: {
    plugin: string;
    data: {
      videoroom?: string;
      [key: string]: unknown;
    };
  };
  jsep?: RTCSessionDescriptionInit;
  candidate?: JanusTrickleCandidate | null;
}

export interface JanusEventHandlers {
  onConnected?: () => void;
  onDisconnected?: () => void;
  onError?: (error: Error) => void;
  onMessage?: (message: JanusResponse) => void | Promise<void>;
}
