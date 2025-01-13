using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Helpers
{
    public   class IPHelper
    {
        public static string GetIpAdress()
        {
            string hostName = Dns.GetHostName();
            string ipAddress = Dns.GetHostAddresses(hostName)
                                 .FirstOrDefault(ip => ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                                 ?.ToString();
            return ipAddress ?? string.Empty; // Return an empty string if no IP is found
        }
    }
}
