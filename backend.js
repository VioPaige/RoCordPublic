// credit: https://github.com/VioPaige

const express = require('express')
const discord = require('discord.js')
const Permissions = discord.Permissions
const noblox = require('noblox.js')
const path = require('path')

const config = require('./config.json')

const application = express()



application.set('views', path.join(__dirname, '/public'))
application.set('view engine', 'ejs')

application.use(express.static(__dirname + '/public'))
application.use(express.urlencoded({extended: true}))
application.use(express.json())

const importantvariables = {
    "rocordguildid": "908060795366162453"
}




const client = new discord.Client({ intents: ["GUILDS", "GUILD_MESSAGES", "DIRECT_MESSAGES", "GUILD_VOICE_STATES"], partials: ["CHANNEL"] })
client.login(config.token)

client.on('ready', () => {




    application.get('/get/guild', async (req, res) => {
        let rocordguild = await client.guilds.fetch(importantvariables.rocordguildid)
        res.send(rocordguild)
    })
    
    application.get('/get/channels', async (req, res) => {
        let rocordguild = await client.guilds.fetch(importantvariables.rocordguildid)
        res.send(rocordguild.channels)
    })
    
    application.get('/get/channel/:id', async (req, res) => {
        const { id } = req.params

        let channel = await client.channels.fetch(id)
        res.send(channel)
    })

    application.get('/get/channelmessages/:id', async (req, res) => {
        const { id } = req.params
        console.log("getting channel messages from channel" + id)

        let channel = await client.channels.fetch(id)
        let messages = await channel.messages.fetch()

        // console.log(messages)
        res.send(messages)
    })

    application.get('/get/messageauthor/:channelid/:messageid', async (req, res) => {
        let { channelid, messageid } = req.params
        let channel = await client.channels.fetch(channelid)
        let message = await channel.messages.fetch(messageid)
        res.send(message.author)
    })

    application.get('/post/message/:name/:channelid/:content', async (req, res) => {
        let { name, channelid, content } = req.params
        let channel = await client.channels.fetch(channelid)

        let messagecontent = `**${name} says:** ${content}`

        channel.send(`${messagecontent}`).then(() => {
            res.send("success")
        }).catch(() => {
            console.error
        })

    })
    
    
    
    let PORT = process.env.PORT || 3000
    application.listen(PORT, () => {
        console.log(`listening on ${PORT}`)
    })









})
