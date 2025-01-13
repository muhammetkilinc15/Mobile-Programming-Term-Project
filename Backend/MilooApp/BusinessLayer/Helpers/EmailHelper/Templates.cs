using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Helpers.EmailHelper
{
    public static class Templates
    {
        public const string VERIFICATION_EMAIL_TEMPLATE = @"
<!DOCTYPE html>
<html lang='tr'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <title>E-postanızı Doğrulayın</title>
</head>
<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>
  <div style='background: linear-gradient(to right, #4CAF50, #45a049); padding: 20px; text-align: center;'>
    <h1 style='color: white; margin: 0;'>E-postanızı Doğrulayın</h1>
  </div>
  <div style='background-color: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);'>
    <p>Merhaba, {username}</p>
    <p>Kayıt olduğunuz için teşekkür ederiz! Doğrulama kodunuz:</p>
    <div style='text-align: center; margin: 30px 0;'>
      <span style='font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #4CAF50;'>{verificationCode}</span>
    </div>
    <p>Kayıt işlemini tamamlamak için bu kodu doğrulama sayfasına girin.</p>
    <p>Güvenlik sebebiyle bu kod 15 dakika içinde geçerliliğini yitirecektir.</p>
    <p>Eğer bu hesabı siz oluşturmadıysanız, lütfen bu e-postayı görmezden gelin.</p>
    <p>Saygılarımızla,<strong>HaytekHub</strong></p>
  </div>
  <div style='text-align: center; margin-top: 20px; color: #888; font-size: 0.8em;'>
    <p>Bu otomatik bir mesajdır, lütfen yanıtlamayın.</p>
  </div>
</body>
</html>
";

        public const string PASSWORD_RESET_SUCCESS_TEMPLATE = @"
<!DOCTYPE html>
<html lang='tr'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <title>Şifre Sıfırlama Başarılı</title>
</head>
<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>
  <div style='background: linear-gradient(to right, #4CAF50, #45a049); padding: 20px; text-align: center;'>
    <h1 style='color: white; margin: 0;'>Şifre Sıfırlama Başarılı</h1>
  </div>
  <div style='background-color: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);'>
    <p>Merhaba, {username},</p>
    <p>Şifrenizin başarıyla sıfırlandığını onaylamak için bu e-postayı gönderiyoruz.</p>
    <div style='text-align: center; margin: 30px 0;'>
      <div style='background-color: #4CAF50; color: white; width: 50px; height: 50px; line-height: 50px; border-radius: 50%; display: inline-block; font-size: 30px;'>
        ✓
      </div>
    </div>
    <p>Eğer bu şifre sıfırlama işlemini siz başlatmadıysanız, lütfen hemen destek ekibimizle iletişime geçin.</p>
    <p>Güvenliğiniz için şunları öneriyoruz:</p>
    <ul>
      <li>Güçlü ve benzersiz bir şifre kullanın</li>
      <li>Varsa iki faktörlü kimlik doğrulamayı etkinleştirin</li>
      <li>Aynı şifreyi birden fazla sitede kullanmaktan kaçının</li>
    </ul>
    <p>Hesabınızı güvende tutmamıza yardımcı olduğunuz için teşekkür ederiz.</p>
    <p>Saygılarımızla,<br>HaytekHub</p>
  </div>
  <div style='text-align: center; margin-top: 20px; color: #888; font-size: 0.8em;'>
    <p>Bu otomatik bir mesajdır, lütfen bu e-postaya cevap vermeyin.</p>
  </div>
</body>
</html>
";

        public const string PASSWORD_RESET_REQUEST_TEMPLATE = @"
<!DOCTYPE html>
<html lang='tr'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <title>Şifrenizi Sıfırlayın</title>
</head>
<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>
  <div style='background: linear-gradient(to right, #4CAF50, #45a049); padding: 20px; text-align: center;'>
    <h1 style='color: white; margin: 0;'>Şifre Sıfırlama</h1>
  </div>
  <div style='background-color: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);'>
    <p>Merhaba, {username},</p>
    <p>Şifrenizi sıfırlamak için bir talep aldık. Eğer bu talebi siz yapmadıysanız, bu e-postayı görmezden gelebilirsiniz.</p>
    <p>Şifrenizi sıfırlamak için aşağıdaki butona tıklayın:</p>
    <div style='text-align: center; margin: 30px 0;'>
      <a href='{resetURL}' style='background-color: #4CAF50; color: white; padding: 12px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;'>Şifreyi Sıfırla</a>
    </div>
    <p>Bu bağlantı güvenlik sebebiyle 1 saat içinde geçerliliğini yitirecektir.</p>
    <p>Saygılarımızla,<br>HaytekHub</p>
  </div>
  <div style='text-align: center; margin-top: 20px; color: #888; font-size: 0.8em;'>
    <p>Bu otomatik bir mesajdır, lütfen bu e-postaya cevap vermeyin.</p>
  </div>
</body>
</html>
";
    }

}
