// credit: https://github.com/VioPaige

// WHEN RUNNING THIS LOCALLY FOR DATA TESTING FOR LOCAL LINKS, LIKE LOCALHOST:3000/GET/CHANNELMESSAGES/CHANNELID, MAKE SURE YOU HAVE THE FOLLOWING MODULES INSTALLED:
/*
express - (npm install express)
discord.js - (npm install discord.js)
ejs - (npm install ejs)

also, either make a config.json file in the same folder/dir, or replace where the token is with your own token. (DO NOT LEAK YOUR TOKEN)


AT LAST, THERE'S A FEW LINES WHERE YOU NEED TO EDIT VARIABLES, THESE ARE: 38, 103
*/


// Requiring modules:
const express = require('express')
const discord = require('discord.js')
const Permissions = discord.Permissions
// const noblox = require('noblox.js')
const path = require('path')

const config = require('./config.json')

const application = express()



//Express module settings, for reference
application.set('views', path.join(__dirname, '/public'))
application.set('view engine', 'ejs')

application.use(express.static(__dirname + '/public'))
application.use(express.urlencoded({extended: true}))
application.use(express.json())

const importantvariables = {
    "rocordguildid": "YOUR GUILD ID HERE" //fill in your guild id here
}




const client = new discord.Client({ intents: ["GUILDS", "GUILD_MESSAGES", "DIRECT_MESSAGES", "GUILD_VOICE_STATES"], partials: ["CHANNEL"] })
client.login(config.token) //If you didn't make a config.json file, please insert your bot token here as a string.

client.on('ready', () => {




    application.get('/get/guild', async (req, res) => { // function for retrieving all guild/server info
        let rocordguild = await client.guilds.fetch(importantvariables.rocordguildid)
        res.send(rocordguild)
    })
    
    application.get('/get/channels', async (req, res) => { // function for retrieving channels of the guild/server
        let rocordguild = await client.guilds.fetch(importantvariables.rocordguildid)
        res.send(rocordguild.channels)
    })
    
    application.get('/get/channel/:id', async (req, res) => { // function for retrieving channel info of a specific channel, by id
        const { id } = req.params

        let channel = await client.channels.fetch(id)
        res.send(channel)
    })

    application.get('/get/channelmessages/:id', async (req, res) => { // function for retrieving messages from a specific channel, by id
        const { id } = req.params
        console.log("getting channel messages from channel" + id)

        let channel = await client.channels.fetch(id)
        let messages = await channel.messages.fetch()

        // console.log(messages)
        res.send(messages)
    })

    application.get('/get/messageauthor/:channelid/:messageid', async (req, res) => { // function for retrieving data about who sent a message, by channel and message id
        let { channelid, messageid } = req.params
        let channel = await client.channels.fetch(channelid)
        let message = await channel.messages.fetch(messageid)
        res.send(message.author)
    })

    application.get('/post/message/:name/:channelid/:content', async (req, res) => { // function for posting messages, params: roblox username, channel id, message content
        let { name, channelid, content } = req.params
        let channel = await client.channels.fetch(channelid)

        let messagecontent = `**${name} says:** ${content}`

        channel.send(`${messagecontent}`).then(() => {
            res.send("success")
        }).catch(() => {
            console.error
        })

    })
    
    
    
    let PORT = process.env.PORT || 3000 // change 3000 to any localhost:<port> that you'd like to host it on when hosting locally
    application.listen(PORT, () => {
        console.log(`listening on ${PORT}`)
    })









})
