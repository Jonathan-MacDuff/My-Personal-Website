

function Contact() {

    return (
        <div>
            <h1>Contact Me</h1>
            <form>
                <input type='name' placeholder='Name'/>
                <input type='tel' placeholder='Phone'/>
                <input type='email' placeholder='Email'/>
                <textarea placeholder='Message'/>
                {/* add checkboxes for prefered contact method */}
                <button type='submit'>Submit</button>
            </form>
        </div>
    )
};

export default Contact;