train_subjects = [1 2 5 7 8 9 10 12 14 15 16 17 18 19 20 22 23];
test_subjects = [3 4 6 11 13 21];

N1 = length(train_subjects);
N2 = length(test_subjects);

files = {};

lbl = [1 1 1 2 2 2 3 3 3 4 4 4];

train_ids = 1:(N1*12);
train_lbl = repmat(lbl, 1, N1);

test_ids = (N1*12+1):((N1+N2)*12);
test_lbl = repmat(lbl, 1, N2);

names = {
    'prawo'
    'lewo'
    'stop'
    'start'
};

for k=1:N1
    for n=1:length(names)
        for f=1:3
            s = sprintf("data/%02d/%s_%d.wav", train_subjects(k), names{n}, f);
            files{end+1,1} = s;
        end
    end
end

for k=1:N2
    for n=1:length(names)
        for f=1:3
            s = sprintf("data/%02d/%s_%d.wav", test_subjects(k), names{n}, f);
            files{end+1,1} = s;
        end
    end
end

% zakładamy takie samo fs dla wszystkich nagrań
[~, fs] = audioread(files{1});

data = {};

for k=1:length(files)
    data{k} = audioread(files{k});
end
