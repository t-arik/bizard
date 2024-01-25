FROM elixir:1.16.0
WORKDIR /app
COPY mix.exs ./
RUN mix deps.get
RUN mix compile

COPY . .
RUN mix deps.get
RUN mix compile

ENV PORT=2000
CMD ["mix", "run", "--no-halt"]
EXPOSE 2000
