import { useEffect, useRef } from 'react';
import './RemoteVideo.css';

interface RemoteVideoProps {
  stream: MediaStream | null;
  displayName?: string;
}

export function RemoteVideo({ stream, displayName = 'Remote' }: RemoteVideoProps) {
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    if (videoRef.current && stream) {
      videoRef.current.srcObject = stream;
    }
  }, [stream]);

  if (!stream) {
    return (
      <div className="remote-video-container">
        <div className="remote-video-placeholder">
          <div className="placeholder-icon">👤</div>
          <div className="placeholder-text">Waiting for another person...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="remote-video-container">
      <video
        ref={videoRef}
        autoPlay
        playsInline
        className="remote-video"
      />
      <div className="remote-video-label">{displayName}</div>
    </div>
  );
}
