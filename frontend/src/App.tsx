import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Home } from '@pages/Home';
import { Call } from '@pages/Call';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/call" element={<Call />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
