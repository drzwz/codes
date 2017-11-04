using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.OleDb;

namespace testSAS
{
    class Program
    {
        static void Main(string[] args)
        {
            //先引用SAS IOM、SASObjectManager
            //OF SD WS OK
            SASObjectManager.ObjectFactoryClass sasOF = new SASObjectManager.ObjectFactoryClass();
            SASObjectManager.ServerDefClass sasSD = new SASObjectManager.ServerDefClass();
            sasSD.MachineDNSName = "localhost";
            sasSD.Protocol = SASObjectManager.Protocols.ProtocolCom;
            SAS.Workspace sasWS = (SAS.Workspace)sasOF.CreateObjectByServer("", true, sasSD, null, null);
            SASObjectManager.ObjectKeeperClass sasOK = new SASObjectManager.ObjectKeeperClass();
            sasOK.AddObject(1, "mySAS", sasWS);

            //SAS.Libref libRef = ws.DataService.AssignLibref("fin", "", @"d:\fin\sas\data\", "");
            SAS.LanguageService sasLS = sasWS.LanguageService;
            string query = @"libname fin 'd:\fin\sas\data\';";
            query += "proc sql; create table fin.test1 as select * from fin.test;quit;";
            sasLS.Submit(query);
            OleDbDataAdapter da = new OleDbDataAdapter("select * from fin.test1 where f3>0",
                "Provider=sas.IOMProvider.1;SAS Workspace ID=" + sasWS.UniqueIdentifier + ";");
            DataSet ds = new DataSet();
            da.Fill(ds, "test");
            foreach (DataRow dr in ds.Tables["test"].Rows)
            {
                Console.WriteLine("{0} {1}", Convert.IsDBNull(dr[0]) ? "" :Convert.ToString(dr[0]), Convert.IsDBNull(dr[0]) ? "" : Convert.ToString(dr[2]));
             }

            sasOK.RemoveObject(sasWS);//...............
            sasWS.Close(); 




            //OleDbConnection cn = new OleDbConnection("Provider=sas.IOMProvider.1; Data Source=_LOCAL_");
            //cn.Open();
            //OleDbCommand cmd = cn.CreateCommand();
            //cmd.CommandType = CommandType.Text;
            //cmd.CommandText = @"libname fin 'd:\fin\sas\data'";
            //cmd.ExecuteNonQuery();
            //cmd.CommandText = @"select * from fin.test";
            //OleDbDataReader reader = cmd.ExecuteReader();
            //int i = 0;
            //while (i++ < 20 && reader.Read()) 
            //{
            //    Console.WriteLine("{0} {1}", reader.GetValue(0).ToString(), reader.GetValue(2).ToString());
            //}
            //reader.Close();
            //cmd.CommandText = @"insert into fin.test(f1,f2,f3) values('aaaa',1111,222)";
            //cmd.ExecuteNonQuery();
            //cn.Close();

            Console.ReadKey();
        }
    }
}
