import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Home.css';

export function Home() {
  const [roomId, setRoomId] = useState('');
  const [displayName, setDisplayName] = useState('');
  const navigate = useNavigate();

  const handleJoinRoom = (e: React.FormEvent) => {
    e.preventDefault();

    if (roomId.trim() && displayName.trim()) {
      navigate(`/call?room=${encodeURIComponent(roomId)}&name=${encodeURIComponent(displayName)}`);
    }
  };

  const handleCreateRoom = () => {
    const newRoomId = Math.random().toString(36).substring(2, 10);
    setRoomId(newRoomId);
  };

  return (
    <div className="home-container">
      <div className="home-content">
        <h1 className="home-title">VideoRTC</h1>
        <p className="home-subtitle">Simple WebRTC Video Calls</p>

        <form onSubmit={handleJoinRoom} className="home-form">
          <div className="form-group">
            <label htmlFor="displayName">Your Name</label>
            <input
              id="displayName"
              type="text"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              placeholder="Enter your name"
              required
              maxLength={50}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="roomId">Room ID</label>
            <div className="room-input-group">
              <input
                id="roomId"
                type="text"
                value={roomId}
                onChange={(e) => setRoomId(e.target.value)}
                placeholder="Enter room ID"
                required
                maxLength={20}
                className="form-input"
              />
              <button
                type="button"
                onClick={handleCreateRoom}
                className="create-room-button"
                title="Generate random room ID"
              >
                Generate
              </button>
            </div>
          </div>

          <button type="submit" className="join-button">
            Join Call
          </button>
        </form>

        <div className="home-info">
          <h3>How it works:</h3>
          <ol>
            <li>Enter your name</li>
            <li>Create a new room or enter an existing room ID</li>
            <li>Share the room ID with someone</li>
            <li>Start video calling!</li>
          </ol>
        </div>
      </div>
    </div>
  );
}
