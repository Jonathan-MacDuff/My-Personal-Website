import { NavLink } from 'react-router-dom';
import '../index.css';

function Navbar() {
  return (
    <nav className="navbar">
      <ul className="nav-links">
        <li className="nav-link">
          <NavLink to='/' end className={({ isActive }) => isActive ? "active" : undefined}>Home</NavLink>
        </li>
        <li className="nav-link">
          <NavLink to='/about' className={({ isActive }) => isActive ? "active" : undefined}>About</NavLink>
        </li>
        <li className="nav-link">
          <NavLink to='/projects' className={({ isActive }) => isActive ? "active" : undefined}>Projects</NavLink>
        </li>
        <li className="nav-link">
          <NavLink to='/contact' className={({ isActive }) => isActive ? "active" : undefined}>Contact</NavLink>
        </li>
        <li className="nav-link">
          <NavLink to='/links' className={({ isActive }) => isActive ? "active" : undefined}>Links</NavLink>
        </li>
      </ul>
    </nav>
  );
};

export default Navbar;