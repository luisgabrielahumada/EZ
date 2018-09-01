using System;
using System.Collections.Generic;

namespace Request.Services.Rules.Interface
{
    public partial interface IRequest
    {
        Guid DB_SearchVessel_Step1(Guid token, int ProductId
                                 , int StowageFactorId
                                 , float StowageFactor
                                 , int QuantityId
                                 , float Quantity
                                 , int ToleranceId
                                 , int Terms
                                 , int LoadingConditionId
                                 , int UnLoadingConditionId
                                 , int LoadPortId
                                 , int LoadTerminalId
                                 , float LoadingRate
                                 , int DischargePortId
                                 , int DischargeTerminalId
                                 , float UnLoadingRate
                                 , DateTime StartLaycan
                                 , DateTime EndLaycan
                                 , int UpdatedId);

        dynamic DB_SearchVessel_Get(Guid Token, int UpdatedId, int? VesselId);

        List<dynamic> DB_SearchVessel_Step2(Guid Token, String Status, bool Continue, int UpdatedId);

        List<dynamic> DB_SearchVessel_Continue(Guid RequestToken, String Token, int UpdatedId);

        List<dynamic> DB_ChangeStatusRequestVessel_Save(Guid Token, String Status, float PriceMT, int UpdatedId);

        List<dynamic> DB_ChangeStatusRequest_Save(Guid Token, String Status, int UpdatedId);

        List<dynamic> DB_ItemsLiquidationForServices_List(Guid Token, int UpdatedId);

        List<dynamic> DB_RequesForServices_List(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int ProductId, int StowageFactorId,
                                                 int QuantityId, int LoadingConditionId, int UnLoadingConditionId, int LoadPortId, int LoadTerminalId, int DischargePortId, int DischargeTerminalId, DateTime StartLaycan, DateTime EndLaycan);

        List<dynamic> DB_ServiceLiquidationsForRquest_List(int PageIndex, int PageSize, Guid token, int UpdatedId, out int TotalRecords);

        List<dynamic> DB_InboxCustomer_List(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int ProductId, int StowageFactorId,
                                                         int QuantityId, int LoadPortId, int LoadTerminalId, int DischargePortId, int DischargeTerminalId, DateTime StartLaycan, DateTime EndLaycan, String Status);

        List<dynamic> DB_InboxVessel_List(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int ProductId, int StowageFactorId,
                                                 int QuantityId, int LoadPortId, int LoadTerminalId, int DischargePortId, int DischargeTerminalId, DateTime StartLaycan, DateTime EndLaycan, String Status);

        dynamic DB_VariableLiquidation_Get(Guid Token);

        void DB_UpdateVariableLiquidation(Guid token, float RateLoading, float RateUnLoading, float ValueLoadingCondition, float ValueUnLoadingCondition, float Quantity, float IfoLoadPort, float MgoLoadPort,
                                            float LoadingRate, float UnLoadingRate, float VesselSpeed, float VesselIfoConsumed, float VesselMgoConsumed, int UpdatedId);
    }
}