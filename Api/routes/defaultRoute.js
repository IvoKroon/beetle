module.exports = app => {
    app.get('/', (req, res) => {
        res.json({ 'Welcome': 'Welcome to the api' });
    });
    app.post('/test', (req, res) => {
        console.log(req.body);
        if (req.body.title) {
            console.log('TITLE : ', req.body.title);
        }
        res.json(req.body)
    })
}