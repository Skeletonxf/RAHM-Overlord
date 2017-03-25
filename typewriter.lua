-- adapted from https://github.com/Skeletonxf/menu-system/blob/master/menuSystem/interface/menu/typewriter.lua

local typewriter = {
  _VERSION = "autotyping 0.1",
  _DESCRIPTION = "takes a string and slowly 'types' it out",
  _URL = "https://github.com/Skeletonxf/menu-system",
  _LICENSE = [[
  ZLIB license (see ObjectClass)
  Copyright © 2016 Skeletonxf
  ]],
  _INFO = "see bottom of this file for an example"
  }

local Typewriter = {name="writer",defaultTime=0.05}
Typewriter.__index = Typewriter

function Typewriter:update(dt)
    if self.text then
        if self.text ~= self.fullText then
            self.incrementTime = ( self.incrementTime or 0 ) + dt
            local stringLength = self.text:len()
            local addChar = string.sub(self.fullText,stringLength+1,stringLength+1)
            local priorChar = string.sub(self.fullText,stringLength,stringLength)
            local waitTime = self.defaultTime
            if self.specialDelays then
            for k, v in pairs(self.specialDelays) do
                if k == priorChar then
                    waitTime = v
                    break
                end
            end
            end
            if self.incrementTime > waitTime then
                self.incrementTime = self.incrementTime - waitTime
                self.text = self.text .. addChar
            end
        end
    else
        if self.fullText then
            self.text = string.sub(self.fullText,1,1)
        else
            error("no text given to typewriter",2,debug.traceback)
        end
    end
end

function Typewriter:getText()
    return self.text or ""
end

function Typewriter:getTextProgress()
    return self.text:len()/self.fullText:len()
end

-- resets the string completely
function Typewriter:setText(text)
    self.fullText = text
    self.text = nil
end

-- pass args in as a table containing
-- configuration settings for the
-- Typewriter object
-- {fullText="Your text will go here",
-- defaultTime=0.05,
--  specialDelays={["x"]=0.12}}
function typewriter.new(args)
    local object = {}
    setmetatable(object,Typewriter)
    object:setText(args)
    return object
end

--[[
Example use
typewriter = require("typewriter")

local textObject

local text = "Text goes here
and when you see dots the
text takes longer to autotype.....
and-this-also-takes-a-bit-longer-to
type than normal"


function love.load()
    textObject = typewriter.newWriter{fullText=text,
    specialDelays={["."]=0.12,["-"]=0.08}
    }
end

function love.update(dt)
    textObject:update(dt)
    if textObject:getTextProgress() == 1 then
        textObject:setText(text)
    end
end

function love.draw()
    love.graphics.printf(textObject:getText() or "",0,0,480)
end
]]

return typewriter