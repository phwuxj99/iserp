
	[Function(Name="dbo.GetBomdetailsSorted")]
	public ISingleResult<bom_detail> GetBomdetailsSorted([Parameter(DbType="NVarChar(100)")] string sortExpression, [Parameter(DbType="Int")] System.Nullable<int> startRowIndex, [Parameter(DbType="Int")] System.Nullable<int> maximumRows, [Parameter(DbType="VarChar(35)")] string p_bomno, [Parameter(DbType="Int")] ref System.Nullable<int> rowcount)
	{
		IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, startRowIndex, maximumRows, p_bomno, rowcount);
		rowcount = ((System.Nullable<int>)(result.GetParameterValue(4)));
        return ((ISingleResult<bom_detail>)(result.ReturnValue));
	}
	
	[Function(Name="dbo.GetBomSorted")]
    public ISingleResult<bom_title> GetBomSorted([Parameter(DbType="NVarChar(100)")] string sortExpression, [Parameter(DbType="VarChar(15)")] string sortDirection, [Parameter(DbType="Int")] System.Nullable<int> startRowIndex, [Parameter(DbType="Int")] System.Nullable<int> maximumRows, [Parameter(DbType="VarChar(35)")] string p_bomno, [Parameter(DbType="Int")] ref System.Nullable<int> rowcount)
	{
		IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, sortDirection, startRowIndex, maximumRows, p_bomno, rowcount);
		rowcount = ((System.Nullable<int>)(result.GetParameterValue(5)));
        return ((ISingleResult<bom_title>)(result.ReturnValue));
	}
	
	[Function(Name="dbo.GetClientSorted")]
    public ISingleResult<erpclient> GetClientSorted([Parameter(DbType="NVarChar(100)")] string sortExpression, [Parameter(DbType="VarChar(15)")] string sortDirection, [Parameter(DbType="Int")] System.Nullable<int> startRowIndex, [Parameter(DbType="Int")] System.Nullable<int> maximumRows, [Parameter(DbType="VarChar(35)")] string p_cname_code, [Parameter(DbType="Int")] ref System.Nullable<int> rowcount)
	{
		IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, sortDirection, startRowIndex, maximumRows, p_cname_code, rowcount);
		rowcount = ((System.Nullable<int>)(result.GetParameterValue(5)));
        return ((ISingleResult<erpclient>)(result.ReturnValue));
	}

    [Function(Name = "GetSupplySorted")]
    public ISingleResult<erpsupply> GetSupplySorted([Parameter(DbType = "NVarChar(100)")] string sortExpression, [Parameter(DbType = "VarChar(15)")] string sortDirection, [Parameter(DbType = "Int")] System.Nullable<int> startRowIndex, [Parameter(DbType = "Int")] System.Nullable<int> maximumRows, [Parameter(DbType = "VarChar(35)")] string p_cname_code, [Parameter(DbType = "Int")] ref System.Nullable<int> rowcount)
    {
        IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, sortDirection, startRowIndex, maximumRows, p_cname_code, rowcount);
        rowcount = ((System.Nullable<int>)(result.GetParameterValue(5)));
        return ((ISingleResult<erpsupply>)(result.ReturnValue));
    } 
	
	[Function(Name="dbo.GetWarehouseSorted")]
    public ISingleResult<warehouse> GetWarehouseSorted([Parameter(DbType="NVarChar(100)")] string sortExpression, [Parameter(DbType="VarChar(15)")] string sortDirection, [Parameter(DbType="Int")] System.Nullable<int> startRowIndex, [Parameter(DbType="Int")] System.Nullable<int> maximumRows, [Parameter(DbType="VarChar(35)")] string p_partno, [Parameter(DbType="Int")] ref System.Nullable<int> rowcount)
	{
		IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, sortDirection, startRowIndex, maximumRows, p_partno, rowcount);
		rowcount = ((System.Nullable<int>)(result.GetParameterValue(5)));
        return ((ISingleResult<warehouse>)(result.ReturnValue));
	}
	
	[Function(Name="dbo.GetWhReceiptSorted")]
    public ISingleResult<wh_receipt> GetWhReceiptSorted([Parameter(DbType="NVarChar(100)")] string sortExpression, [Parameter(DbType="VarChar(15)")] string sortDirection, [Parameter(DbType="Int")] System.Nullable<int> startRowIndex, [Parameter(DbType="Int")] System.Nullable<int> maximumRows, [Parameter(DbType="VarChar(35)")] string p_whre_no, [Parameter(DbType="VarChar(15)")] string p_BeginDate, [Parameter(DbType="VarChar(15)")] string p_EndDate, [Parameter(DbType="Int")] ref System.Nullable<int> rowcount)
	{
		IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, sortDirection, startRowIndex, maximumRows, p_whre_no, p_BeginDate, p_EndDate, rowcount);
		rowcount = ((System.Nullable<int>)(result.GetParameterValue(7)));
        return ((ISingleResult<wh_receipt>)(result.ReturnValue));
	}
	
	[Function(Name="dbo.GetWhReceiptSortedConfirmed")]
    public ISingleResult<wh_receipt> GetWhReceiptSortedConfirmed([Parameter(DbType = "NVarChar(100)")] string sortExpression, [Parameter(DbType = "VarChar(15)")] string sortDirection, [Parameter(DbType = "Int")] System.Nullable<int> startRowIndex, [Parameter(DbType = "Int")] System.Nullable<int> maximumRows, [Parameter(DbType = "VarChar(35)")] string p_whre_no, [Parameter(DbType = "VarChar(15)")] string p_BeginDate, [Parameter(DbType = "VarChar(15)")] string p_EndDate, [Parameter(DbType = "Int")] ref System.Nullable<int> rowcount)
	{
		IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, sortDirection, startRowIndex, maximumRows, p_whre_no, p_BeginDate, p_EndDate, rowcount);
		rowcount = ((System.Nullable<int>)(result.GetParameterValue(7)));
        return ((ISingleResult<wh_receipt>)(result.ReturnValue));
	}
	