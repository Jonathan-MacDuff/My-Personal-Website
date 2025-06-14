

function Contact() {

    return (
        <div>
            <h1>Contact Me</h1>
            <form>
                <input placeholder='Name'/>
                <input placeholder='Phone'/>
                <input placeholder='Email'/>
                <textarea placeholder='Message'/>
                {/* add checkboxes for prefered contact method */}
                <button type='submit'>Submit</button>
            </form>
        </div>
    )
};

export default Contact;