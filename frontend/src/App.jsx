import React, { useState } from 'react';
import './App.css';

function App() {
  const [status, setStatus] = useState('');
  
  const apiEndpoint = import.meta.env.VITE_API_URL;
  console.log('API Endpoint:', apiEndpoint);

  const sendEvent = async (eventType) => {
    const event = {
      event_type: eventType,
      user_id: 'user_' + Math.floor(Math.random() * 1000),
      timestamp: new Date().toISOString(),
      device: navigator.userAgent
    };

    try {
      const response = await fetch(apiEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(event)
      });

      if (!response.ok) throw new Error('Network response was not ok');
      
      setStatus(`✅ Event sent: ${eventType}`);
      console.log('Event sent:', event);
    } catch (error) {
      console.error('Error sending event:', error);
      setStatus('❌ Failed to send event');
    }
  };

  return (
    <div className="App">
      <h1>StartSmart Event Simulator</h1>
      <button onClick={() => sendEvent('page_view')}>Page View</button>
      <button onClick={() => sendEvent('login')}>Login</button>
      <button onClick={() => sendEvent('purchase')}>Purchase</button>
      <p>{status}</p>
    </div>
  );
}

export default App;
