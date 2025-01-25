﻿ENT.Type = "anim"
ENT.PrintName = "Telephone"
ENT.Category = "Lilia"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.IsPersistent = true
if SERVER then
    TAKEN_NUMBERS = TAKEN_NUMBERS or {}
    function ENT:Initialize()
        self:SetModel("models/par_rotary_phone_01/par_rotary_phone_01.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then phys:Wake() end
        self:setNetVar("ringing", false)
        self:setNetVar("inUse", false)
        self:GenerateNumber()
        netstream.Start(nil, "sendPhoneNumbers", GetAllPhoneNumbersCL())
    end

    function ENT:GenerateNumber()
        local tries = 100
        local setNumber = false
        while tries > 0 do
            local generatedNum = tostring(math.random(1111, 9999))
            if TAKEN_NUMBERS[generatedNum] == nil then
                TAKEN_NUMBERS[generatedNum] = true
                self:SetNumber(generatedNum)
                self:setNetVar("number", generatedNum)
                setNumber = true
                break
            end

            tries = tries - 1
        end

        if not setNumber then self:Remove() end
    end

    function ENT:OnDuplicated(entTbl)
        if entTbl.DT.Number then
            if self:GetNumber() then TAKEN_NUMBERS[self:GetNumber()] = nil end
            if TAKEN_NUMBERS[entTbl.DT.Number] then
                self:GenerateNumber()
            else
                TAKEN_NUMBERS[entTbl.DT.Number] = true
                self:SetNumber(entTbl.DT.Number)
                self:setNetVar("number", entTbl.DT.Number)
            end
        end
    end

    function ENT:Use(ply)
        netstream.Start(ply, "OpenPhoneDialer", self, false)
        self:setNetVar("user", ply)
        if self:getNetVar("ringing", false) then self:RingStop(self:getNetVar("caller")) end
    end

    function ENT:RingStart(caller, num)
        self:setNetVar("ringing", true)
        self:setNetVar("caller", caller)
        self:setNetVar("callerNum", num)
        self.ring = CreateSound(self, "telephone/phonering.wav")
        self.ring:Play()
    end

    function ENT:RingStop(caller)
        self:setNetVar("ringing", false)
        self.ring:Stop()
        self.ring = nil
    end

    function ENT:ResetVars()
        self:setNetVar("caller", nil)
        self:setNetVar("callerNum", nil)
    end

    function ENT:OnRemove()
        TAKEN_NUMBERS[self:GetNumber()] = nil
        if SERVER then netstream.Start(nil, "sendPhoneNumbers", GetAllPhoneNumbersCL()) end
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Number")
end
