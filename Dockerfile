# Базовый образ на основе Ubuntu 20.04
FROM ubuntu:22.04

# Устанавливаем переменную окружения для неинтерактивной установки
ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y \
    gcc-arm-none-eabi \
    cmake \
    make \
    git \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Создаём рабочую директорию
WORKDIR /app

# Копируем локальный проект
COPY . .

# Клонируем STM32CubeF1 в /STM32CubeF1
RUN git clone https://github.com/STMicroelectronics/STM32CubeF1.git /STM32CubeF1

# Проверяем содержимое директории STM32CubeF1
RUN ls -la /STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/ || echo "Directory not found!"

# Проверяем конкретный файл
RUN ls -la /STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio_ex.c || echo "File stm32f1xx_hal_gpio_ex.c not found!"

# Создаём директорию для сборки и выполняем сборку
RUN rm -f CMakeCache.txt && \
    mkdir -p build && cd build && cmake .. && make

# Команда по умолчанию
CMD ["make", "-C", "build"]