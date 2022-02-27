using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EDP_Project
{
    public partial class AdminReportedReview : System.Web.UI.Page
    {
        MyDBServiceReference.Service1Client client = new MyDBServiceReference.Service1Client();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                populate_listview();
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            populate_listview();

            base.OnPreRender(e);
        }
        protected void populate_listview()
        {
            DataSet ds = client.SelectReportedReview();
            ListViewReview.DataSource = ds;
            ListViewReview.DataBind();
        }



        protected void ButtonReset_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            client.ResetNumReportToReview(int.Parse(btn.CommandArgument));
            alert.Visible = true;
            lblAlert.Text = "Report reset Successfully!";
        }
        protected void ButtonDelete_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            client.DeleteReview(int.Parse(btn.CommandArgument));
            alert.Visible = true;
            lblAlert.Text = "Review Delete Successfully!";
        }

    }
}