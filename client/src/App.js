import './App.css';
import {Route, Routes} from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import About from './pages/About';
import Projects from './pages/Projects';
import Contact from './pages/Contact';

function App() {
  return (
    <div>
      <Navbar>
      </Navbar>
      <Routes>
        <Route path='/' element={ <Home/> }></Route>
        <Route path='/about' element={ <About/> }></Route>
        <Route path='/projects' element={ <Projects/> }></Route>
        <Route path='/contact' element={ <Contact/> }></Route>
      </Routes>
    </div>
  );
}

export default App;
