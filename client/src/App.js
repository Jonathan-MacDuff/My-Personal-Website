import './App.css';
import {Route, Routes} from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import About from './pages/About';
import Projects from './pages/Projects';

function App() {
  return (
    <div>
      <Navbar>
      </Navbar>
      <Routes>
        <Route path='/' element={ <Home/> }></Route>
        <Route path='/about' element={ <About/> }></Route>
        <Route path='/projects' element={ <Projects/> }></Route>
      </Routes>
    </div>
  );
}

export default App;
