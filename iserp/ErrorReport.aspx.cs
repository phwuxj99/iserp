using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;

namespace iserp
{
    public partial class ErrorReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }


        protected void btnSend_Click(object sender, System.EventArgs e)
        {
            try
            {
                string str_from_address = txtEmail.Text.Trim();
                string str_name = "ERROR REPORT";
                string str_to_address = "admin@infoccc.com";

                //Create MailMessage Object
                MailMessage email_msg = new MailMessage();

                //Specifying From,Sender & Reply to address
                email_msg.From = new MailAddress(str_from_address, str_name);
                email_msg.Sender = new MailAddress(str_from_address, str_name);
                // email_msg.ReplyTo = new MailAddress(str_from_address, str_name);

                //The To Email id
                email_msg.To.Add(str_to_address);

                email_msg.Subject = "From - " + txbName.Text.Trim() + " - " + txbCompany.Text.Trim();
                email_msg.Body = editor.Content;// txbMessage.Text;
                email_msg.Priority = MailPriority.Normal;
                email_msg.IsBodyHtml = true;

                //Create an object for SmtpClient class
                SmtpClient mail_client = new SmtpClient();

                //Providing Credentials (Username & password)
                NetworkCredential network_cdr = new NetworkCredential();
                network_cdr.UserName = "tech@infoccc.com";
                network_cdr.Password = "1qaz2wsx";

                mail_client.Host = "mail.infoccc.com";
                mail_client.UseDefaultCredentials = true;
                mail_client.Credentials = network_cdr;
                //Specify the SMTP Port
                mail_client.Port = 587;

                //Now Send the message
                mail_client.Send(email_msg);

                ErrorMsg.Text = "Email Sent Successfully";

            }
            catch (Exception ex)
            {
                //Some error occured
                ErrorMsg.Text = ex.Message.ToString();
            }
        }
    }
}