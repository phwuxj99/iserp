using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using System.Data.Linq.SqlClient;

namespace iserp.Services
{
    public class WordResult
    {
        public string Word { get; set; }
        public int Length { get; set; }
        public string Reversed { get; set; }
    }

    [ServiceContract(Namespace = "")]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class AutoComplete
    {
        // To use HTTP GET, add [WebGet] attribute. (Default ResponseFormat is WebMessageFormat.Json)
        // To create an operation that returns XML,
        //     add [WebGet(ResponseFormat=WebMessageFormat.Xml)],
        //     and include the following line in the operation body:
        //         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml";
        [OperationContract]

        //[WebGet(ResponseFormat = WebMessageFormat.Json)]
        //public WordResult[] WordLookup(string text, int count)
        //{
        //    count = count > 20 ? 20 : count;
        //    count = count < 0 ? 1 : count;

        //    var result = (from word in GetAllWords()
        //                  where word.Contains(text)
        //                  select new WordResult
        //                  {
        //                      Word = word,
        //                      Length = word.Length,
        //                      Reversed = Reverse(word)
        //                  })
        //                  .Take(count)
        //                  .ToArray();
        //    return result;
        //}

        //public static string Reverse(string s)
        //{
        //    char[] charArray = s.ToCharArray();
        //    Array.Reverse(charArray);
        //    return new string(charArray);
        //}
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        private IList<string> GetAllWords(string keywordStartsWith, int limit)
        {
            StringBuilder sb = new StringBuilder();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var query =
                   from ord in db.partnos
                   //where ord.part_no.StartsWith(keywordStartsWith)
                   where SqlMethods.Like(ord.part_no, "%" + keywordStartsWith + "%")
                   select ord;

                // Execute the query, and change the column values
                // you want to change.
                //foreach (App_Data.partno ord in query)
                foreach (var ord in query)
                {
                    sb.Append(Convert.ToString(ord.part_no.Trim() + "|"));
                }

                //return Convert.ToString(sb);
            }
            ////TODO: implement real search here!

            //// dummy implementation
            IList<string> output = new List<string>();
            output = sb.ToString().Split('|');
            //output.Add(keywordStartsWith + "1");
            //output.Add(keywordStartsWith + "2");
            //output.Add(keywordStartsWith + "3");
            //output.Add(keywordStartsWith + "4");
            return output;
        }

        //public IList<string> GetAllPredictions(string keywordStartsWith)
        //{
        //    StringBuilder sb = new StringBuilder();
        //    using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
        //    {
        //        var query =
        //           from ord in db.partnos
        //           where ord.part_no.StartsWith(keywordStartsWith)
        //           //where SqlMethods.Like(ord.part_no, keywordStartsWith+"%")
        //           select ord;

        //        // Execute the query, and change the column values
        //        // you want to change.
        //        //foreach (App_Data.partno ord in query)
        //        foreach (var ord in query)
        //        {
        //            sb.Append(Convert.ToString(ord.part_no.Trim() + "|"));
        //        }

        //        //return Convert.ToString(sb);
        //    }
        //    ////TODO: implement real search here!

        //    //// dummy implementation
        //    IList<string> output = new List<string>();
        //    output = sb.ToString().Split('|');
        //    //output.Add(keywordStartsWith + "1");
        //    //output.Add(keywordStartsWith + "2");
        //    //output.Add(keywordStartsWith + "3");
        //    //output.Add(keywordStartsWith + "4");
        //    return output;
        //}
        //// Add more operations here and mark them with [OperationContract]
    }
}
