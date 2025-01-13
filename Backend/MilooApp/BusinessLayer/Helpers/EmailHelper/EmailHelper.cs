using BusinessLayer.Parameters;
using Microsoft.Extensions.Configuration;
using System.Net.Mail;
using System.Net;
using Microsoft.Extensions.Options;

namespace BusinessLayer.Helpers.EmailHelper
{
    public class EmailHelper : IEmailHelper
    {
        private readonly EmailSettings _emailSettings;

        public EmailHelper(IOptions<EmailSettings> emailSettings)
        {
            _emailSettings = emailSettings.Value;
        }

        private async Task SendEmailAsync(string toEmail, string subject, string htmlContent)
        {
            var mailMessage = new MailMessage
            {
                From = new MailAddress(_emailSettings.FromEmail, "MilooApp"),
                Subject = subject,
                Body = htmlContent,
                IsBodyHtml = true
            };
            mailMessage.To.Add(toEmail);
            using var smtpClient = new SmtpClient(_emailSettings.Host, _emailSettings.Port);
            smtpClient.Credentials = new NetworkCredential(_emailSettings.Username, _emailSettings.Password);
            smtpClient.EnableSsl = _emailSettings.EnableSsl;

            await smtpClient.SendMailAsync(mailMessage);
        }

        public async Task SendVerificationEmailAsync(string toEmail, string username, string verificationCode)
        {
            string htmlContent = Templates.VERIFICATION_EMAIL_TEMPLATE
                .Replace("{username}", username)
                .Replace("{verificationCode}", verificationCode);

            await SendEmailAsync(toEmail, "E-postanızı Doğrulayın", htmlContent);
        }

        public async Task SendPasswordResetEmailAsync(string toEmail, string username, string resetUrl)
        {
            string htmlContent = Templates.PASSWORD_RESET_REQUEST_TEMPLATE
                .Replace("{username}", username)
                .Replace("{resetURL}", resetUrl);

            await SendEmailAsync(toEmail, "Şifre Sıfırlama Talebi", htmlContent);
        }

        public async Task SendPasswordResetSuccessEmailAsync(string toEmail, string username)
        {
            string htmlContent = Templates.PASSWORD_RESET_SUCCESS_TEMPLATE
                .Replace("{username}", username);

            await SendEmailAsync(toEmail, "Şifre Sıfırlama Başarılı", htmlContent);
        }

    }
}
