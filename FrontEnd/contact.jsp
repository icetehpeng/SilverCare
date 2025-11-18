<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SilverCare - Contact Us</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main>
    <section class="contact-hero">
        <div class="container">
            <div class="contact-hero-content">
                <h1>Contact Us</h1>
                <p class="contact-subtitle">
                    We're here to help. Get in touch with our team for any questions or inquiries.
                </p>
            </div>
        </div>
    </section>

    <section class="contact-content">
        <div class="container">
            <div class="contact-wrapper">
                <div class="contact-info-section">
                    <h2>Get in Touch</h2>
                    <p>
                        Whether you have questions about our services, need assistance with booking, 
                        or want to learn more about how SilverCare can help you or your loved one, 
                        we're here to assist you.
                    </p>

                    <div class="contact-methods">
                        <div class="contact-method-card">
                            <div class="contact-icon">📞</div>
                            <h3>Phone</h3>
                            <p>Call us during business hours</p>
                            <a href="tel:+6512345678" class="contact-link">+65 6123 4567</a>
                            <span class="contact-hours">Mon - Fri: 8:00 AM - 6:00 PM</span>
                        </div>

                        <div class="contact-method-card">
                            <div class="contact-icon">✉️</div>
                            <h3>Email</h3>
                            <p>Send us an email anytime</p>
                            <a href="mailto:info@silvercare.com" class="contact-link">info@silvercare.com</a>
                            <span class="contact-hours">We respond within 24 hours</span>
                        </div>

                        <div class="contact-method-card">
                            <div class="contact-icon">📍</div>
                            <h3>Address</h3>
                            <p>Visit our office</p>
                            <address class="contact-link">
                                123 Care Avenue<br>
                                #05-10 SilverCare Building<br>
                                Singapore 123456
                            </address>
                            <span class="contact-hours">Mon - Fri: 9:00 AM - 5:00 PM</span>
                        </div>
                    </div>

                    <div class="emergency-contact">
                        <h3>Emergency Contact</h3>
                        <p>For urgent care needs outside business hours:</p>
                        <a href="tel:+6598765432" class="emergency-link">+65 9876 5432</a>
                        <span class="emergency-note">Available 24/7 for emergencies</span>
                    </div>

                    <div class="social-media-section">
                        <h3>Follow Us</h3>
                        <p>Connect with us on social media for updates and news</p>
                        <div class="social-media-links">
                            <a href="https://www.facebook.com/silvercare" target="_blank" rel="noopener noreferrer" aria-label="Facebook" class="social-link facebook">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>
                                </svg>
                            </a>
                            <a href="https://www.instagram.com/silvercare" target="_blank" rel="noopener noreferrer" aria-label="Instagram" class="social-link instagram">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="2" y="2" width="20" height="20" rx="5" ry="5"/>
                                    <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/>
                                    <line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/>
                                </svg>
                            </a>
                            <a href="https://www.twitter.com/silvercare" target="_blank" rel="noopener noreferrer" aria-label="Twitter" class="social-link twitter">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z"/>
                                </svg>
                            </a>
                            <a href="https://www.linkedin.com/company/silvercare" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn" class="social-link linkedin">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/>
                                    <rect x="2" y="9" width="4" height="12"/>
                                    <circle cx="4" cy="4" r="2"/>
                                </svg>
                            </a>
                            <a href="https://www.youtube.com/silvercare" target="_blank" rel="noopener noreferrer" aria-label="YouTube" class="social-link youtube">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M22.54 6.42a2.78 2.78 0 0 0-1.94-2C18.88 4 12 4 12 4s-6.88 0-8.6.46a2.78 2.78 0 0 0-1.94 2A29 29 0 0 0 1 11.75a29 29 0 0 0 .46 5.33A2.78 2.78 0 0 0 3.4 19c1.72.46 8.6.46 8.6.46s6.88 0 8.6-.46a2.78 2.78 0 0 0 1.94-2 29 29 0 0 0 .46-5.25 29 29 0 0 0-.46-5.33z"/>
                                    <polygon points="9.75 15.02 15.5 11.75 9.75 8.48 9.75 15.02"/>
                                </svg>
                            </a>
                            <a href="https://wa.me/6598765432" target="_blank" rel="noopener noreferrer" aria-label="WhatsApp" class="social-link whatsapp">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z"/>
                                </svg>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="contact-form-section">
                    <h2>Send us a Message</h2>
                    <p>Fill out the form below and we'll get back to you as soon as possible.</p>
                    
                    <form class="contact-form" method="POST" action="#">
                        <div class="input-group">
                            <label for="name">Full Name *</label>
                            <input type="text" id="name" name="name" placeholder="Enter your full name" required>
                        </div>

                        <div class="input-group">
                            <label for="email">Email Address *</label>
                            <input type="email" id="email" name="email" placeholder="your.email@example.com" required>
                        </div>

                        <div class="input-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" placeholder="+65 1234 5678">
                        </div>

                        <div class="input-group">
                            <label for="subject">Subject *</label>
                            <select id="subject" name="subject" required>
                                <option value="">Select a subject</option>
                                <option value="general">General Inquiry</option>
                                <option value="services">Service Information</option>
                                <option value="booking">Booking Request</option>
                                <option value="support">Customer Support</option>
                                <option value="feedback">Feedback</option>
                                <option value="other">Other</option>
                            </select>
                        </div>

                        <div class="input-group">
                            <label for="message">Message *</label>
                            <textarea id="message" name="message" rows="6" placeholder="Tell us how we can help you..." required></textarea>
                        </div>

                        <button type="submit" class="button button-primary full-width">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <section class="office-hours">
        <div class="container">
            <h2>Office Hours</h2>
            <div class="hours-grid">
                <div class="hours-card">
                    <h3>Monday - Friday</h3>
                    <p class="hours-time">8:00 AM - 6:00 PM</p>
                </div>
                <div class="hours-card">
                    <h3>Saturday</h3>
                    <p class="hours-time">9:00 AM - 2:00 PM</p>
                </div>
                <div class="hours-card">
                    <h3>Sunday</h3>
                    <p class="hours-time">Closed</p>
                </div>
                <div class="hours-card">
                    <h3>Public Holidays</h3>
                    <p class="hours-time">Closed</p>
                </div>
            </div>
            <p class="hours-note">
                <strong>Note:</strong> Emergency services are available 24/7. Please call our emergency hotline for urgent care needs.
            </p>
        </div>
    </section>
</main>

<%@ include file="footer.html" %>

</body>
</html>

