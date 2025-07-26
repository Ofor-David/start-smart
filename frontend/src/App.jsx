import React, { useState } from 'react';
import './App.css';

function App() {
  const [status, setStatus] = useState('');
  const apiEndpoint = import.meta.env.VITE_API_URL;
  console.log('API Endpoint:', apiEndpoint);

  const sendEvent = async (eventType) => {
    // Fake data for testing
    const now = new Date();
    const startTime = now.toISOString();
    const endTime = new Date(now.getTime() + 3600000).toISOString(); // +1 hour

    const event = {
      title: `Test ${eventType}`,
      description: `Triggered event type: ${eventType}`,
      startTime,
      endTime
    };

    try {
      const response = await fetch(apiEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(event)
      });

      if (!response.ok) throw new Error('Network response was not ok');

      const result = await response.json();
      console.log('Event sent:', result);
      setStatus(`✅ ${eventType} event sent successfully`);
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
