Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

# MapTheMakers

MapTheMakers is a Ruby on Rails web application that helps users discover and explore creative “makers” around the world. The app uses a searchable maker directory combined with an interactive map to help people connect with creators based on location and category.

> **Note:** This project is a learning rebuild inspired by the original Le Wagon group project created by [Alizée Driget](https://github.com/alizeedriget) and her team.

## Features

* **User Authentication** – Sign up, log in, and manage profiles (Devise).
* **Makers Directory** – Browse makers with images, categories, and descriptions.
* **Interactive Map** – Mapbox integration to display maker locations.
* **Search & Filters** – Search by name, category, or location.
* **Maker Profiles** – Detailed pages for each maker with contact info.
* **Responsive Design** – Works across mobile, tablet, and desktop.

## Tech Stack

* **Backend:** Ruby on Rails 7
* **Frontend:** HTML, SCSS, JavaScript (ES6)
* **Auth:** Devise
* **Database:** PostgreSQL
* **Maps:** Mapbox API
* **Hosting:** Heroku

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/gyansingh18/mapthemakers.git
   cd mapthemakers
   ```
2. Install dependencies:

   ```bash
   bundle install
   yarn install
   ```
3. Set up the database:

   ```bash
   rails db:create db:migrate db:seed
   ```
4. Create a `.env` file and add your Mapbox API key:

   ```
   MAPBOX_API_KEY=your_mapbox_key_here
   ```
5. Start the server:

   ```bash
   rails s
   ```
6. Open `http://localhost:3000` in your browser.

## My Contribution

As part of rebuilding this project for learning purposes, I worked on:

* Setting up **Devise authentication** for user sign-up/login.
* Implementing **search and filter** functionality for makers by name, category, and location.
* Integrating **Mapbox** to display makers on an interactive map.
* Styling and structuring **maker profile pages** with images and descriptions.
* Ensuring **responsive UI** across devices.
* Writing **seed data** to populate makers and categories for testing.

## Team

* **Gyan Singh** – Developer (Learning Rebuild)
* [Alizée Driget](https://github.com/alizeedriget) – Original project inspiration
* Le Wagon Bali Batch #xxx

## License

For educational purposes only.

