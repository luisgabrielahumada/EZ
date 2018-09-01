using System;
using System.Collections.Generic;

namespace Request.Services.Rules.Interface
{
    public interface IRequestTask
    {
        Guid Step(Guid Token, int ProductId
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

        dynamic GetRequest(Guid Token, int UpdatedId, int? VesselId);

        List<dynamic> Step2(Guid Token, String Status, bool Continue, int UpdatedId);

        List<dynamic> ChangeStatusRequest(Guid Token, String Status, int UpdatedId);

        List<dynamic> Continue(Guid token, List<Guid> Token, int UpdatedId);

        List<dynamic> RequesForServices(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int productId, int stowageFactorId,
                                                int quantityId, int LoadingConditionId, int UnLoadingConditionId, int loadPortId, int loadTerminalId, int dischargePortId, int dischargeTerminalId, DateTime startLaycan, DateTime endLaycan);

        List<dynamic> ServiceLiquidationsForRquest(int PageIndex, int PageSize, Guid token, int updatedId, out int TotalRecords);

        List<dynamic> ItemsLiquidationForServices(Guid token, int UpdatedId);

        List<dynamic> ChangeStatus(Guid Token, string Status, float PriceMT, int UpdatedId);

        List<dynamic> InboxCustomerRequest(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int productId, int stowageFactorId,
                                                int quantityId, int loadPortId, int loadTerminalId, int dischargePortId, int dischargeTerminalId, DateTime startLaycan, DateTime endLaycan, String Status);

        List<dynamic> InboxVesselRequest(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int productId, int stowageFactorId,
                                                int quantityId, int loadPortId, int loadTerminalId, int dischargePortId, int dischargeTerminalId, DateTime startLaycan, DateTime endLaycan, String Status);


        dynamic VariableLiquidation(Guid Token);

        void UpdateVariableLiquidation(Guid Token,float RateLoading, float RateUnLoading, float ValueLoadingCondition, float ValueUnLoadingCondition, float Quantity, float IfoLoadPort, float MgoLoadPort,
                                            float LoadingRate, float UnLoadingRate, float VesselSpeed, float VesselIfoConsumed, float VesselMgoConsumed, int UpdatedId);
    }
}