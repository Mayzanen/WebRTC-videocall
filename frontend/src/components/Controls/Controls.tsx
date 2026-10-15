import './Controls.css';

interface ControlsProps {
  audioEnabled: boolean;
  videoEnabled: boolean;
  onToggleAudio: () => void;
  onToggleVideo: () => void;
  onHangup: () => void;
}

function MicrophoneIcon({ muted }: { muted: boolean }) {
  return (
    <svg className="control-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
      <path d="M12 14a3 3 0 0 0 3-3V5a3 3 0 0 0-6 0v6a3 3 0 0 0 3 3Zm5.3-3a5.3 5.3 0 0 1-10.6 0H5a7 7 0 0 0 6 6.92V21H8v2h8v-2h-3v-3.08A7 7 0 0 0 19 11h-1.7Z" />
      {muted && <path className="control-icon-slash" d="m4 4 16 16" />}
    </svg>
  );
}

function CameraIcon({ disabled }: { disabled: boolean }) {
  return (
    <svg className="control-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
      <path d="M15 6H5c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2v-3.5l4 4v-9l-4 4V8c0-1.1-.9-2-2-2Z" />
      {disabled && <path className="control-icon-slash" d="m4 4 16 16" />}
    </svg>
  );
}

function HangupIcon() {
  return (
    <svg className="control-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
      <path d="M12 8c-3.4 0-6.52.85-9.08 2.3a1 1 0 0 0-.46 1.13l.72 2.47a1 1 0 0 0 1.45.6l2.1-1.13a1 1 0 0 0 .5-.87v-1.16c1.53-.35 3.13-.53 4.77-.53s3.24.18 4.77.53v1.16c0 .36.19.69.5.87l2.1 1.13a1 1 0 0 0 1.45-.6l.72-2.47a1 1 0 0 0-.46-1.13A18.42 18.42 0 0 0 12 8Z" />
    </svg>
  );
}

export function Controls({
  audioEnabled,
  videoEnabled,
  onToggleAudio,
  onToggleVideo,
  onHangup,
}: ControlsProps) {
  return (
    <div className="controls-container">
      <button
        className={`control-button ${audioEnabled ? 'active' : 'inactive'}`}
        onClick={onToggleAudio}
        aria-label={audioEnabled ? 'Mute microphone' : 'Unmute microphone'}
        aria-pressed={!audioEnabled}
        title={audioEnabled ? 'Mute' : 'Unmute'}
      >
        <MicrophoneIcon muted={!audioEnabled} />
      </button>

      <button
        className={`control-button ${videoEnabled ? 'active' : 'inactive'}`}
        onClick={onToggleVideo}
        aria-label={videoEnabled ? 'Turn off camera' : 'Turn on camera'}
        aria-pressed={!videoEnabled}
        title={videoEnabled ? 'Stop Video' : 'Start Video'}
      >
        <CameraIcon disabled={!videoEnabled} />
      </button>

      <button
        className="control-button hangup"
        onClick={onHangup}
        aria-label="End call"
        title="Hang Up"
      >
        <HangupIcon />
      </button>
    </div>
  );
}
