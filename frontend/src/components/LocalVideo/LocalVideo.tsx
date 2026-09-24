import { useEffect, useRef } from 'react';
import './LocalVideo.css';

interface LocalVideoProps {
  stream: MediaStream | null;
  muted?: boolean;
  displayName?: string;
}

export function LocalVideo({ stream, muted = true, displayName = 'You' }: LocalVideoProps) {
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    if (videoRef.current && stream) {
      videoRef.current.srcObject = stream;
    }
  }, [stream]);

  return (
    <div className="local-video-container">
      <video
        ref={videoRef}
        autoPlay
        playsInline
        muted={muted}
        className="local-video"
      />
      <div className="local-video-label">{displayName}</div>
    </div>
  );
}
