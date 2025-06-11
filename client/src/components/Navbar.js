import React from 'react';
import { Link } from 'react-router-dom';
import '../index.css';

const Navbar = () => {
  return (
    <nav className="navbar">
      <ul className="nav-links">
        <li className="nav-link"><Link to='/'>Home</Link></li>
        <li className="nav-link"><Link to='/about'>About</Link></li>
        <li className="nav-link"><Link to='/projects'>Projects</Link></li>
      </ul>
    </nav>
  );
};

export default Navbar;