import dracula.draw

# Load existing settings made via :set
config.load_autoconfig()

c.url.start_pages = 'http://172.104.177.135:3333/'
dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})
