

function Contact() {

    return (
        <div>
            <h1>Contact Me</h1>
            <form>
                <input type='name' placeholder='Name'/>
                <input type='tel' placeholder='Phone'/>
                <input type='email' placeholder='Email'/>
                <textarea placeholder='Message'/>
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