using BusinessLayer.Parameters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Helpers.EmailHelper
{
    public interface IEmailHelper
    {
        Task SendVerificationEmailAsync(string toEmail, string username, string verificationCode);
        Task SendPasswordResetEmailAsync(string toEmail, string username, string resetUrl);
        Task SendPasswordResetSuccessEmailAsync(string toEmail, string username);
    }
}
