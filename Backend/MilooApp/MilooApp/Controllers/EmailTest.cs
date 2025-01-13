using BusinessLayer.Helpers.EmailHelper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MilooApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailTest : ControllerBase
    {
        private readonly IEmailHelper emailHelper;

        public EmailTest(IEmailHelper emailHelper)
        {
            this.emailHelper = emailHelper;
        }

        [HttpPost("send-verification-email")]
        public async Task<IActionResult> SendVerificationEmail(string toEmail,string username,string verificationCode="3131")
        {
            await emailHelper.SendVerificationEmailAsync(toEmail, username, verificationCode);
            return Ok("Verification email sent successfully.");
        }
    }
}
