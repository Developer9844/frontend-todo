require('dotenv').config();  // Load .env file

module.exports = {
    apps: [
        {
            name: 'frontend',
            script: 'src/app.js',
            watch: true,
            env: {
                NODE_ENV: 'development',
                PORT: process.env.PORT,
                API_URL: process.env.API_URL
            }
        }
    ]
};
