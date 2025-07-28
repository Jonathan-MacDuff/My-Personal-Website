import { useState } from 'react';

function Contact() {
  const [formData, setFormData] = useState({
    name: '',
    phone: '',
    email: '',
    message: '',
    contactMethods: {
      call: false,
      text: false,
      email: false,
    },
  });

  const [status, setStatus] = useState('');

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;

    if (type === 'checkbox') {
      setFormData((prev) => ({
        ...prev,
        contactMethods: {
          ...prev.contactMethods,
          [name]: checked,
        },
      }));
    } else {
      setFormData((prev) => ({
        ...prev,
        [name]: value,
      }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setStatus('Sending...');

    try {
      const res = await fetch('http://localhost:5000/api/contact', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });

      if (res.ok) {
        setStatus('Message sent!');
        setFormData({
          name: '',
          phone: '',
          email: '',
          message: '',
          contactMethods: {
            call: false,
            text: false,
            email: false,
          },
        });
      } else {
        const err = await res.json();
        setStatus(err.error || 'Failed to send');
      }
    } catch (err) {
      console.error(err);
      setStatus('An error occurred');
    }
  };

  return (
    <div className='form-container'>
      <h1>Contact Me</h1>
      <form className='contact-form' onSubmit={handleSubmit}>
        <label>Full Name
          <input type='text' name='name' value={formData.name} onChange={handleChange} required />
        </label>
        <label>Phone Number
          <input type='tel' name='phone' value={formData.phone} onChange={handleChange} />
        </label>
        <label>Email Address
          <input type='email' name='email' value={formData.email} onChange={handleChange} required />
        </label>
        <label>Message
          <textarea name='message' value={formData.message} onChange={handleChange} required />
        </label>
        <h3>Preferred contact method</h3>
        <label>Call
          <input type='checkbox' name='call' checked={formData.contactMethods.call} onChange={handleChange} />
        </label>
        <label>Text
          <input type='checkbox' name='text' checked={formData.contactMethods.text} onChange={handleChange} />
        </label>
        <label>Email
          <input type='checkbox' name='email' checked={formData.contactMethods.email} onChange={handleChange} />
        </label>
        <button type='submit'>Submit</button>
        {status && <p>{status}</p>}
      </form>
    </div>
  );
}

export default Contact;