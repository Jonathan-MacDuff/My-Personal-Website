

function Contact() {

    return (
        <div className='form-container'>
            <h1>Contact Me</h1>
            <form className='contact-form'>
                <label>Full Name
                    <input type='name'/>
                </label>
                <label>Phone Number
                    <input type='tel'/>
                </label>
                <label>Email Address
                    <input type='email'/>
                </label>
                <label>Message
                    <textarea type='message'/>
                </label>
                <h3>Prefered contact method</h3>
                    <label>Call
                        <input type='checkbox'/>
                    </label>
                    <label>Text
                        <input type='checkbox'/>
                    </label>
                    <label>Email
                        <input type='checkbox'/>
                    </label>
                <button type='submit'>Submit</button>
            </form>
        </div>
    )
};

export default Contact;