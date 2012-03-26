using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Data.Linq.SqlClient;


namespace iserp.Services
{
    /// <summary>
    /// Summary description for PartnoWebService
    /// </summary>
    /// 
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    //[System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class PartnoWebService : System.Web.Services.WebService
    {
        public PartnoWebService()
        {
        }

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public string[] GetCompletionList(string prefixText, int count)
        {
            List<string> output = new List<string>();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var query =
                   from ord in db.partnos
                   //where ord.part_no.StartsWith(prefixText)
                   where SqlMethods.Like(ord.part_no, "%" + prefixText + "%")
                   select ord;

                foreach (var ord in query)
                {
                    output.Add(ord.part_no.Trim());
                }

                //return Convert.ToString(sb);
            }
            ////TODO: implement real search here!

            return output.ToArray();


            //if (count == 0)
            //{
            //    count = 10;
            //}

            //if (prefixText.Equals("xyz"))
            //{
            //    return new string[0];
            //}

            //if (prefixText.Equals("xyz"))
            //{
            //    return new string[0];
            //}

            //Random random = new Random();
            //List<string> items = new List<string>(count);
            //for (int i = 0; i < count; i++)
            //{
            //    char c1 = (char)random.Next(65, 90);
            //    char c2 = (char)random.Next(97, 122);
            //    char c3 = (char)random.Next(97, 122);

            //    items.Add(prefixText + c1 + c2 + c3);
            //}

            //return items.ToArray();
        }
    }
}
